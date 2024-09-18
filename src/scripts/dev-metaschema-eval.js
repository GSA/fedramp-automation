import { execSync } from 'child_process';
import fs from 'fs';
import inquirer from 'inquirer';
import { JSDOM } from 'jsdom';
import { evaluateMetapath } from 'oscal';
import path from 'path';
import { fileURLToPath } from 'url';
const prompt = inquirer.prompt;
// Get the directory name of the current module
const __filename = fileURLToPath(import.meta.url);
const __dirname = path.dirname(__filename);
// Constants
const contentDir = path.join(__dirname, '../../src', 'validations', 'constraints', 'content');



// Function to parse XML and extract relevant part based on XPath
async function extractXmlPart(xmlFilePath, xpath) {
    const xmlContent = await fs.promises.readFile(xmlFilePath, 'utf8');
    const dom = new JSDOM(xmlContent, { contentType: "text/xml" });
    const document = dom.window.document;

    const result = document.evaluate(
        xpath,
        document,
        null,
        dom.window.XPathResult.FIRST_ORDERED_NODE_TYPE,
        null
    );

    if (result.singleNodeValue) {
        return result.singleNodeValue.outerHTML;
    }
    return null;
}
// Helper function to parse XML nodes recursively
function parseNode(node) {
    if (node.nodeType === node.TEXT_NODE) {
        return node.textContent.trim();
    }

    if (node.nodeType === node.ELEMENT_NODE) {
        const result = {
            _name: node.nodeName,
            _attributes: {},
            _content: {}
        };

        // Parse attributes
        for (const attr of node.attributes) {
            result._attributes[attr.name] = attr.value;
        }

        // Parse child nodes
        for (const child of node.childNodes) {
            if (child.nodeType === child.ELEMENT_NODE) {
                const childResult = parseNode(child);
                if (result._content[child.nodeName]) {
                    if (!Array.isArray(result._content[child.nodeName])) {
                        result._content[child.nodeName] = [result._content[child.nodeName]];
                    }
                    result._content[child.nodeName].push(childResult);
                } else {
                    result._content[child.nodeName] = childResult;
                }
            } else if (child.nodeType === child.TEXT_NODE && child.textContent.trim()) {
                result._content._text = child.textContent.trim();
            }
        }

        // If the node has no attributes and only text content, return the text directly
        if (Object.keys(result._attributes).length === 0 && 
            Object.keys(result._content).length === 1 && 
            result._content._text) {
            return result._content._text;
        }

        return result;
    }

    return null;
}


// Function to select a content file
async function selectContentFile() {
    const xmlFiles = fs.readdirSync(contentDir).filter(file => file.endsWith('.xml'));
    const { selectedFile } = await prompt([
        {
            type: 'list',
            name: 'selectedFile',
            message: 'Select an XML file to query against:',
            choices: xmlFiles
        }
    ]);
    return path.join(contentDir, selectedFile);
}

// Main function to query metapath
async function queryMetapath(metapath, contentFile = null) {
    if (!metapath) {
        console.error('Metapath is required');
        return;
    }

    let inputFile = contentFile;
    if (!inputFile) {
        inputFile = await selectContentFile();
    }

    console.log(`Querying metapath: ${metapath}`);
    console.log(`Against file: ${inputFile}`);
    const command = "metaschema metapath eval";
    const result = await evaluateMetapath({document:inputFile,expression:metapath,metaschema:"./vendor/oscal/src/metaschema/oscal_complete_metaschema.xml"});
    if (result) {
        console.log(`metapath result: ${result}`);
        let items = [result]
        if(result.startsWith("(")){
            items = result.substring(1,result.length-1).split(",");
        }
        items.forEach(async (item)=>{
            const [file,path] = item.split("#")
            if(typeof path==='undefined'){
                return;
            }
            try{
                const xmlPart = await extractXmlPart(file.replaceAll("file:",""), path);
                if (xmlPart) {
                    console.log(xmlPart);
                } else {
                    console.log('Unable to extract XML part for the given XPath.');
                }    
            }catch(e){
                console.log(file)
                console.log(path);
                console.log("failed to execute");
                console.log(e);
            }
    
        })
    } else {
        console.log('Unable to get XPath result from oscal-cli command.');
    }
}


// If this script is run directly, execute the queryMetapath function with command line arguments
    let metapath = process.argv[2];
    const contentFile = process.argv[3];
    if (!metapath) {
        const { inputMetapath } = await prompt([
            {
                type: 'input',
                name: 'inputMetapath',
                message: 'Enter the metapath to query:',
                validate: input => input.trim() !== '' || 'Metapath is required'
            }
        ]);
        metapath = inputMetapath;
    }
    queryMetapath(metapath, contentFile).catch(console.error);
