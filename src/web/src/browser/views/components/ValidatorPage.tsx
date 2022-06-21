import React from 'react';

import { getUrl, Routes } from '@asap/browser/presenter/state/router';
import type { OscalDocumentKey } from '@asap/shared/domain/oscal';

import { ValidatorFileSelectForm } from './ValidatorFileSelectForm';
import { ValidatorReport } from './ValidatorReport';
import { ValidatorResultsFilterForm } from './ValidatorResultsFilterForm';
import { useAppState } from '../hooks';

const DocumentValidator = ({
  documentType,
}: {
  documentType: OscalDocumentKey;
}) => (
  <>
    <div className="grid-row grid-gap">
      <div className="mobile:grid-col-12 tablet:grid-col-4">
        <div className="position-sticky top-0bg-white padding-top-4">
          <ValidatorResultsFilterForm documentType={documentType} />
        </div>
      </div>
      <div className="mobile:grid-col-12 tablet:grid-col-8">
        <ValidatorReport documentType={documentType} />
      </div>
    </div>
  </>
);

export const ValidatorPage = ({
  documentType,
}: {
  documentType: OscalDocumentKey | null;
}) => {
  const { oscalDocuments, router } = useAppState();
  return (
    <>
      <div className="grid-row">
        <h1>FedRAMP OSCAL Document Rules</h1>
        <div className="mobile:grid-col-12">
          You may use this tool to browse FedRAMP OSCAL validation rules and
          apply them to your own documents.
        </div>
      </div>
      <div className="grid-row grid-gap">
        <div className="tablet:grid-col-12">
          <h1>Choose an XML file to process</h1>
        </div>
        <ValidatorFileSelectForm />
      </div>
      <div>
        <ul>
          <li>
            {router.currentRoute.type === 'DocumentSummary' ? (
              'Summary'
            ) : (
              <a href={getUrl(Routes.documentSummary)}>Summary</a>
            )}
          </li>
          <li>
            {router.currentRoute.type === 'DocumentPOAM' ? (
              'Plan of Action and Milestones'
            ) : (
              <a href={getUrl(Routes.documentPOAM)}>
                Plan of Action and Milestones
              </a>
            )}
          </li>
          <li>
            {router.currentRoute.type === 'DocumentSAP' ? (
              'Security Assessment Plan'
            ) : (
              <a href={getUrl(Routes.documentSAP)}>Security Assessment Plan</a>
            )}
          </li>
          <li>
            {router.currentRoute.type === 'DocumentSAR' ? (
              'Security Assessment Report'
            ) : (
              <a href={getUrl(Routes.documentSAR)}>
                Security Assessment Report
              </a>
            )}
          </li>
          <li>
            {router.currentRoute.type === 'DocumentSSP' ? (
              'System Security Plan'
            ) : (
              <a href={getUrl(Routes.documentSSP)}>System Security Plan</a>
            )}
          </li>
        </ul>
      </div>
      {documentType ? (
        <DocumentValidator documentType={documentType} />
      ) : (
        <table className="usa-table">
          <thead>
            <tr>
              <th>Document</th>
              <th>Rules</th>
              <th>Flagged</th>
            </tr>
          </thead>
          <tbody>
            <tr>
              <td>
                <a href={getUrl(Routes.documentSSP)}>System Security Plan</a>
              </td>
              <td>{oscalDocuments.ssp.counts.total}</td>
              <td>{oscalDocuments.ssp.counts.fired}</td>
            </tr>
            <tr>
              <td>
                <a href={getUrl(Routes.documentSAR)}>
                  Security Assessment Report
                </a>
              </td>
              <td>{oscalDocuments.sar.counts.total}</td>
              <td>{oscalDocuments.sar.counts.fired}</td>
            </tr>
            <tr>
              <td>
                <a href={getUrl(Routes.documentSAP)}>
                  Security Assessment Plan
                </a>
              </td>
              <td>{oscalDocuments.sap.counts.total}</td>
              <td>{oscalDocuments.sap.counts.fired}</td>
            </tr>
            <tr>
              <td>
                <a href={getUrl(Routes.documentPOAM)}>
                  Plan of Action and Milestones
                </a>
              </td>
              <td>{oscalDocuments.poam.counts.total}</td>
              <td>{oscalDocuments.poam.counts.fired}</td>
            </tr>
          </tbody>
        </table>
      )}
    </>
  );
};
