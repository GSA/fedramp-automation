import { getUrl, Routes } from '@asap/browser/presenter/state/router';
import type { OscalDocumentKey } from '@asap/shared/domain/oscal';
import { HeadingOne } from './HeadingOne';
import { ValidatorFileSelectForm } from './ValidatorFileSelectForm';
import { ValidatorReport } from './ValidatorReport';
import { ValidatorResultsFilterForm } from './ValidatorResultsFilterForm';
import { useAppState } from '../hooks';
import styled from '@emotion/styled';
import { css } from '@emotion/react';
import classNames from 'classNames';
import { number } from 'fp-ts';

const NavLink = styled.a`
  color: var(--theme-grey-text);
  text-decoration: none;
  line-height: 0.9;
  :visited {
    color: var(--theme-grey-text);
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
      {/* 
      TODO: Decide on implementation of this
      <div className="grid-container">
        <nav
          aria-label="Secondary navigation"
          className="usa-nav"
          css={css`
            float: none;
            border-bottom: 1px solid var(--theme-light-grey);
          `}
        >
          <div className="usa-nav__inner">
            <ul className="usa-nav__primary usa-accordion">
              <li className="usa-nav__primary-item">
                <NavLink
                  className={classNames('usa-nav-link', {
                    'usa-current':
                      router.currentRoute.type === 'DocumentSummary',
                  })}
                  href={getUrl(Routes.documentSummary)}
                >
                  <span>Summary</span>
                </NavLink>
              </li>
              <li className="usa-nav__primary-item">
                <NavLink
                  className={classNames({
                    'usa-current': router.currentRoute.type === 'DocumentPOAM',
                  })}
                  href={getUrl(Routes.documentPOAM)}
                >
                  Plan of Action and Milestones
                </NavLink>
              </li>
              <li className="usa-nav__primary-item">
                <NavLink
                  className={classNames({
                    'usa-current': router.currentRoute.type === 'DocumentSAP',
                  })}
                  href={getUrl(Routes.documentSAP)}
                >
                  Security Assessment Plan
                </NavLink>
              </li>
              <li className="usa-nav__primary-item">
                <NavLink
                  className={classNames({
                    'usa-current': router.currentRoute.type === 'DocumentSAR',
                  })}
                  href={getUrl(Routes.documentSAR)}
                >
                  Security Assessment Report
                </NavLink>
              </li>
              <li className="usa-nav__primary-item">
                <NavLink
                  className={classNames({
                    'usa-current': router.currentRoute.type === 'DocumentSSP',
                  })}
                  href={getUrl(Routes.documentSSP)}
                >
                  System Security Plan
                </NavLink>
              </li>
            </ul>
          </div>
        </nav>
      </div> */}
      <nav className="padding-y-2 border-base-light border-bottom-1px">
        <div className="grid-container grid-row flex-row flex-justify">
          <NavLink
            className={classNames({
              'active-link': router.currentRoute.type === 'DocumentSummary',
            })}
            href={getUrl(Routes.documentSummary)}
          >
            Summary
          </NavLink>
          <NavLink
            className={classNames({
              'active-link': router.currentRoute.type === 'DocumentPOAM',
            })}
            href={getUrl(Routes.documentPOAM)}
          >
            Plan of Action and Milestones
            {oscalDocuments.poam.counts.fired > 0 && (
              <span
                className="usa-tag margin-left-1"
                css={css`
                  background-color: var(--theme-red);
                `}
              >
                {oscalDocuments.poam.counts.fired}
              </span>
            )}
          </NavLink>
          <NavLink
            className={classNames({
              'active-link': router.currentRoute.type === 'DocumentSAP',
            })}
            href={getUrl(Routes.documentSAP)}
          >
            Security Assessment Plan
            {oscalDocuments.sap.counts.fired > 0 && (
              <span
                className="usa-tag margin-left-1"
                css={css`
                  background-color: var(--theme-red);
                `}
              >
                {oscalDocuments.sap.counts.fired}
              </span>
            )}
          </NavLink>
          <NavLink
            className={classNames({
              'active-link': router.currentRoute.type === 'DocumentSAR',
            })}
            href={getUrl(Routes.documentSAR)}
          >
            Security Assessment Report
            {oscalDocuments.sar.counts.fired > 0 && (
              <span
                className="usa-tag margin-left-1"
                css={css`
                  background-color: var(--theme-red);
                `}
              >
                {oscalDocuments.sar.counts.fired}
              </span>
            )}
          </NavLink>
          <NavLink
            className={classNames({
              'active-link': router.currentRoute.type === 'DocumentSSP',
            })}
            href={getUrl(Routes.documentSSP)}
          >
            System Security Plan
            {oscalDocuments.ssp.counts.fired > 0 && (
              <span
                className="usa-tag margin-left-1"
                css={css`
                  background-color: var(--theme-red);
                `}
              >
                {oscalDocuments.ssp.counts.fired}
              </span>
            )}
          </NavLink>
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
