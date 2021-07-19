declare module 'saxon-js' {
  namespace SaxonJS {
    function transform(options: Transformation.Options): Transformation.Results;
    function transform(
      options: Transformation.Options,
      execution: 'sync',
    ): Transformation.Results;
    function transform(
      options: Transformation.Options,
      execution: 'async',
    ): Promise<Transformation.Results>;
    namespace Transformation {
      interface Results {
        principalResult: any;
        resultDocuments: any;
        stylesheetInternal: any;
        masterDocument: Document;
      }
      interface Options
        extends Partial<Stylesheet>,
          Partial<SourceXmlInput>,
          Partial<InvocationOptions>,
          Partial<AdditionalResources>,
          Partial<ResultDelivery>,
          Partial<TransformationBehaviour> {}
      interface Stylesheet {
        stylesheetLocation: string;
        stylesheetFileName: string;
        stylesheetText: string;
        stylesheetInternal: any;
        stylesheetBaseURI: string;
      }
      interface SourceXmlInput {
        sourceLocation: string;
        sourceFileName: string;
        sourceNode: Node;
        sourceText: string;
      }
      interface InvocationOptions {
        stylesheetParams: any;
        initialTemplate: string;
        templateParams: any;
        tunnelParams: any;
        initialFunction: string;
        functionParams: any[];
        initialMode: string;
        initialSelection: any;
      }
      interface AdditionalResources {
        documentPool: { [uri: string]: Document };
        textResourcePool: { [uri: string]: string };
      }
      interface ResultDelivery {
        destination:
          | 'replaceBody'
          | 'appendToBody'
          | 'prependToBody'
          | 'raw'
          | 'document'
          | 'application'
          | 'file'
          | 'stdout'
          | 'serialized';
        resultForm: 'default' | 'array' | 'iterator' | 'xdm';
        outputProperties: any;
        deliverMessage: (message: DocumentFragment, errorCode: string) => void;
        deliverResultDocument: (uri: string) => {
          destination:
            | 'html-page'
            | 'raw'
            | 'document'
            | 'serialized'
            | 'file'
            | 'receiver';
          save: (uri: string, value: any, encoding: string) => void;
          receiver: unknown;
        };
        masterDocument: Document;
        baseOutputURI: string;
      }
      interface TransformationBehaviour {
        collations: any;
        collectionFinder: (uri: string) => any;
        logLevel: -1 | 0 | 1 | 2 | 10;
        nonInteractive: boolean;
      }
    }
  }
  export = SaxonJS;
}
