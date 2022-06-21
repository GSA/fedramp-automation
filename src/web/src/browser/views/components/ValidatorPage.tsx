import { getUrl, Routes } from '@asap/browser/presenter/state/router';
import type { OscalDocumentKey } from '@asap/shared/domain/oscal';
import { HeadingOne } from './HeadingOne';
import { ValidatorFileSelectForm } from './ValidatorFileSelectForm';
import { ValidatorReport } from './ValidatorReport';
import { ValidatorResultsFilterForm } from './ValidatorResultsFilterForm';
import { useAppState } from '../hooks';
import classnames from 'classnames';
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
  const { oscalDocuments, router } = useAppState();
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
            {oscalDocuments.poam.counts.fired > 0 && (
              <span className="usa-tag margin-left-1 bg-theme-red">
                {oscalDocuments.poam.counts.fired}
              </span>
            )}
          </a>
          <a
            className={classnames({
              'active-link': router.currentRoute.type === 'DocumentSAP',
            })}
            href={getUrl(Routes.documentSAP)}
          >
            Security Assessment Plan
            {oscalDocuments.sap.counts.fired > 0 && (
              <span className="usa-tag margin-left-1 bg-theme-red">
                {oscalDocuments.sap.counts.fired}
              </span>
            )}
          </a>
          <a
            className={classnames({
              'active-link': router.currentRoute.type === 'DocumentSAR',
            })}
            href={getUrl(Routes.documentSAR)}
          >
            Security Assessment Report
            {oscalDocuments.sar.counts.fired > 0 && (
              <span className="usa-tag margin-left-1 bg-theme-red">
                {oscalDocuments.sar.counts.fired}
              </span>
            )}
          </a>
          <a
            className={classnames({
              'active-link': router.currentRoute.type === 'DocumentSSP',
            })}
            href={getUrl(Routes.documentSSP)}
          >
            System Security Plan
            {oscalDocuments.ssp.counts.fired > 0 && (
              <span className="usa-tag margin-left-1 bg-theme-red">
                {oscalDocuments.ssp.counts.fired}
              </span>
            )}
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
