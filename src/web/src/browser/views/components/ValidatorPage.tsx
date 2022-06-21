import classnames from 'classnames';

import { getUrl, Routes } from '@asap/browser/presenter/state/router';
import type { OscalDocumentKey } from '@asap/shared/domain/oscal';

import { HeadingOne } from './HeadingOne';
import { ValidatorFileSelectForm } from './ValidatorFileSelectForm';
import { ValidatorReport } from './ValidatorReport';
import { ValidatorResultsFilterForm } from './ValidatorResultsFilterForm';
import { useAppContext } from '../context';

import '../styles/ValidatorPage.scss';

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
  const { oscalDocuments, router, validationResults } = useAppContext().state;
  return (
    <>
      <HeadingOne
        heading="FedRAMP OSCAL Document Rules"
        secondaryText="Browse FedRAMP OSCAL validation rules and
          apply them to your own documents"
      />
      <nav
        aria-label="Secondary navigation"
        className="display-none desktop:display-block padding-y-2 border-base-light border-bottom-1px"
      >
        <div className="grid-container grid-row flex-row flex-justify">
          <a
            className={classnames({
              'active-link': router.currentRoute.type === 'DocumentSummary',
            })}
            href={getUrl(Routes.documentSummary)}
          >
            Summary
          </a>
          <a
            className={classnames({
              'active-link': router.currentRoute.type === 'DocumentPOAM',
            })}
            href={getUrl(Routes.documentPOAM)}
          >
            Plan of Action and Milestones
            <span className="usa-tag margin-left-1 bg-theme-red">
              {validationResults.poam.summary.firedCount}
            </span>
          </a>
          <a
            className={classnames({
              'active-link': router.currentRoute.type === 'DocumentSAP',
            })}
            href={getUrl(Routes.documentSAP)}
          >
            Security Assessment Plan
            <span className="usa-tag margin-left-1 bg-theme-red">
              {validationResults.sap.summary.firedCount}
            </span>
          </a>
          <a
            className={classnames({
              'active-link': router.currentRoute.type === 'DocumentSAR',
            })}
            href={getUrl(Routes.documentSAR)}
          >
            Security Assessment Report
            <span className="usa-tag margin-left-1 bg-theme-red">
              {validationResults.sar.summary.firedCount}
            </span>
          </a>
          <a
            className={classnames({
              'active-link': router.currentRoute.type === 'DocumentSSP',
            })}
            href={getUrl(Routes.documentSSP)}
          >
            System Security Plan
            <span className="usa-tag margin-left-1 bg-theme-red">
              {validationResults.ssp.summary.firedCount}
            </span>
          </a>
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
                <td>{oscalDocuments.ssp.config.schematronAsserts.length}</td>
                <td>{validationResults.ssp.summary.firedCount}</td>
              </tr>
              <tr>
                <td>
                  <a href={getUrl(Routes.documentSAR)}>
                    Security Assessment Report
                  </a>
                </td>
                <td>{oscalDocuments.sar.config.schematronAsserts.length}</td>
                <td>{validationResults.sar.summary.firedCount}</td>
              </tr>
              <tr>
                <td>
                  <a href={getUrl(Routes.documentSAP)}>
                    Security Assessment Plan
                  </a>
                </td>
                <td>{oscalDocuments.sap.config.schematronAsserts.length}</td>
                <td>{validationResults.sap.summary.firedCount}</td>
              </tr>
              <tr>
                <td>
                  <a href={getUrl(Routes.documentPOAM)}>
                    Plan of Action and Milestones
                  </a>
                </td>
                <td>{oscalDocuments.poam.config.schematronAsserts.length}</td>
                <td>{validationResults.poam.summary.firedCount}</td>
              </tr>
            </tbody>
          </table>
        )}
      </div>
    </>
  );
};
