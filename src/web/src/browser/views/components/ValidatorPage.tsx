import classnames from 'classnames';

import { getUrl, Routes } from '@asap/browser/presenter/state/router';
import type { OscalDocumentKey } from '@asap/shared/domain/oscal';
import { HeadingOne } from './HeadingOne';
import { ValidatorFileSelectForm } from './ValidatorFileSelectForm';
import { ValidatorReport } from './ValidatorReport';
import { ValidatorResultsFilterForm } from './ValidatorResultsFilterForm';
import { useAppContext } from '../context';
import tableImage from '../images/2022-05-19-first-oscal-system-security-plan.png';
import '../styles/ValidatorPage.scss';

const DocumentValidator = ({
  documentType,
}: {
  documentType: OscalDocumentKey;
}) => (
  <>
    <div className="grid-row tablet:padding-top-5">
      <div className="tablet:grid-col-4">
        <div className="position-sticky top-1 height-viewport overflow-y-auto">
          <ValidatorResultsFilterForm documentType={documentType} />
        </div>
      </div>
      <div className="tablet:grid-col-8 tablet:padding-left-2">
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
        className="display-none desktop:display-block border-base-light border-bottom-1px"
      >
        <div className="grid-container grid-row flex-row flex-justify">
          <a
            className={classnames('padding-2', {
              'active-link': router.currentRoute.type === 'DocumentSummary',
            })}
            href={getUrl(Routes.documentSummary)}
          >
            Summary
          </a>
          <a
            className={classnames('padding-2', {
              'active-link': router.currentRoute.type === 'DocumentPOAM',
            })}
            href={getUrl(Routes.documentPOAM)}
          >
            Plan of Action and Milestones
            {validationResults.poam.current === 'HAS_RESULT' && (
              <span className="usa-tag margin-left-1 bg-theme-red">
                {validationResults.poam.summary.firedCount}
              </span>
            )}
          </a>
          <a
            className={classnames('padding-2', {
              'active-link': router.currentRoute.type === 'DocumentSAP',
            })}
            href={getUrl(Routes.documentSAP)}
          >
            Security Assessment Plan
            {validationResults.sap.current === 'HAS_RESULT' && (
              <span className="usa-tag margin-left-1 bg-theme-red">
                {validationResults.sap.summary.firedCount}
              </span>
            )}
          </a>
          <a
            className={classnames('padding-2', {
              'active-link': router.currentRoute.type === 'DocumentSAR',
            })}
            href={getUrl(Routes.documentSAR)}
          >
            Security Assessment Results
            {validationResults.sar.current === 'HAS_RESULT' && (
              <span className="usa-tag margin-left-1 bg-theme-red">
                {validationResults.sar.summary.firedCount}
              </span>
            )}
          </a>
          <a
            className={classnames('padding-2', {
              'active-link': router.currentRoute.type === 'DocumentSSP',
            })}
            href={getUrl(Routes.documentSSP)}
          >
            System Security Plan
            {validationResults.ssp.current === 'HAS_RESULT' && (
              <span className="usa-tag margin-left-1 bg-theme-red">
                {validationResults.ssp.summary.firedCount}
              </span>
            )}
          </a>
        </div>
      </nav>

      <div className="grid-container">
        <div className="grid-row grid-gap margin-bottom-5">
          <div className="tablet:grid-col-12">
            <h1 className="font-sans-2xl text-light text-theme-dark-blue">
              Choose an XML file to process
            </h1>
          </div>
          <ValidatorFileSelectForm />
        </div>

        {documentType ? (
          <DocumentValidator documentType={documentType} />
        ) : (
          <div className="grid-row grid-gap">
            <div className="desktop:grid-col">
              <h2 className="font-sans-2xl text-light text-theme-dark-blue margin-0 margin-bottom-5">
                Summary Table
              </h2>
              <img src={tableImage} alt="laptop with report on screen" />
            </div>
            <div className="desktop:grid-col tablet:padding-top-8">
              <table className="usa-table">
                <thead>
                  <tr>
                    <th>Document</th>
                    <th>Status</th>
                    <th>Rules</th>
                    <th>Flagged</th>
                  </tr>
                </thead>
                <tbody>
                  <tr>
                    <td>
                      <a href={getUrl(Routes.documentSSP)}>
                        System Security Plan
                      </a>
                    </td>
                    <td
                      className={classnames({
                        'text-success':
                          validationResults.ssp.summary.firedCount ===
                          (0 || null),
                        'text-error':
                          validationResults.ssp.summary.firedCount !== null &&
                          validationResults.ssp.summary.firedCount > 0,
                      })}
                    >
                      <b>
                        {validationResults.ssp.summary.firedCount !== null &&
                        validationResults.ssp.summary.firedCount > 0
                          ? 'FAIL'
                          : 'PASS'}
                      </b>
                    </td>
                    <td>
                      {oscalDocuments.ssp.config.schematronAsserts.length}
                    </td>
                    <td>{validationResults.ssp.summary.firedCount}</td>
                  </tr>
                  <tr>
                    <td>
                      <a href={getUrl(Routes.documentSAR)}>
                        Security Assessment Results
                      </a>
                    </td>
                    <td>
                      <b
                        className={classnames({
                          'text-success':
                            validationResults.sar.summary.firedCount ===
                            (0 || null),
                          'text-error':
                            validationResults.sar.summary.firedCount !== null &&
                            validationResults.sar.summary.firedCount > 0,
                        })}
                      >
                        {validationResults.sar.summary.firedCount !== null &&
                        validationResults.sar.summary.firedCount > 0
                          ? 'FAIL'
                          : 'PASS'}
                      </b>
                    </td>
                    <td>
                      {oscalDocuments.sar.config.schematronAsserts.length}
                    </td>
                    <td>{validationResults.sar.summary.firedCount}</td>
                  </tr>
                  <tr>
                    <td>
                      <a href={getUrl(Routes.documentSAP)}>
                        Security Assessment Plan
                      </a>
                    </td>
                    <td
                      className={classnames({
                        'text-success':
                          validationResults.sap.summary.firedCount ===
                          (0 || null),
                        'text-error':
                          validationResults.sap.summary.firedCount !== null &&
                          validationResults.sap.summary.firedCount > 0,
                      })}
                    >
                      <b>
                        {validationResults.sap.summary.firedCount !== null &&
                        validationResults.sap.summary.firedCount > 0
                          ? 'FAIL'
                          : 'PASS'}
                      </b>
                    </td>
                    <td>
                      {oscalDocuments.sap.config.schematronAsserts.length}
                    </td>
                    <td>{validationResults.sap.summary.firedCount}</td>
                  </tr>
                  <tr>
                    <td>
                      <a href={getUrl(Routes.documentPOAM)}>
                        Plan of Action and Milestones
                      </a>
                    </td>
                    <td
                      className={classnames({
                        'text-success':
                          validationResults.poam.summary.firedCount ===
                          (0 || null),
                        'text-error':
                          validationResults.poam.summary.firedCount !== null &&
                          validationResults.poam.summary.firedCount > 0,
                      })}
                    >
                      <b>
                        {validationResults.poam.summary.firedCount !== null &&
                        validationResults.poam.summary.firedCount > 0
                          ? 'FAIL'
                          : 'PASS'}
                      </b>
                    </td>
                    <td>
                      {oscalDocuments.poam.config.schematronAsserts.length}
                    </td>
                    <td>{validationResults.poam.summary.firedCount}</td>
                  </tr>
                </tbody>
              </table>
            </div>
          </div>
        )}
      </div>
    </>
  );
};
