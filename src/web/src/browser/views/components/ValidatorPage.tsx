import { getUrl, Routes } from '@asap/browser/presenter/state/router';
import type { OscalDocumentKey } from '@asap/shared/domain/oscal';
import { HeadingOne } from './HeadingOne';
import { ValidatorFileSelectForm } from './ValidatorFileSelectForm';
import { ValidatorReport } from './ValidatorReport';
import { ValidatorResultsFilterForm } from './ValidatorResultsFilterForm';
import { useAppState } from '../hooks';
import styled from '@emotion/styled';

const NavLink = styled.a`
  color: var(--theme-grey-text);
  text-decoration: none;
  :visited {
    color: var(--theme-grey-text);
  }
  :active {
    color: var(--theme-color-red);
  }
`;

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
      <HeadingOne
        heading="FedRAMP OSCAL Document Rules"
        secondaryText="Browse FedRAMP OSCAL validation rules and
          apply them to your own documents"
      />
      <nav className="padding-y-2 border-base-light border-bottom-1px">
        <div className="grid-container grid-row flex-row flex-justify">
          {router.currentRoute.type === 'DocumentSummary' ? (
            'Summary'
          ) : (
            <NavLink href={getUrl(Routes.documentSummary)}>Summary</NavLink>
          )}

          {router.currentRoute.type === 'DocumentPOAM' ? (
            'Plan of Action and Milestones'
          ) : (
            <NavLink href={getUrl(Routes.documentPOAM)}>
              Plan of Action and Milestones
            </NavLink>
          )}

          {router.currentRoute.type === 'DocumentSAP' ? (
            'Security Assessment Plan'
          ) : (
            <NavLink href={getUrl(Routes.documentSAP)}>
              Security Assessment Plan
            </NavLink>
          )}

          {router.currentRoute.type === 'DocumentSAR' ? (
            'Security Assessment Report'
          ) : (
            <NavLink href={getUrl(Routes.documentSAR)}>
              Security Assessment Report
            </NavLink>
          )}

          {router.currentRoute.type === 'DocumentSSP' ? (
            'System Security Plan'
          ) : (
            <NavLink href={getUrl(Routes.documentSSP)}>
              System Security Plan
            </NavLink>
          )}
        </div>
      </nav>

      <div className="grid-container">
        <div className="grid-row grid-gap">
          <div className="tablet:grid-col-12">
            <h1>Choose an XML file to process</h1>
          </div>
          <ValidatorFileSelectForm />
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
      </div>
    </>
  );
};
