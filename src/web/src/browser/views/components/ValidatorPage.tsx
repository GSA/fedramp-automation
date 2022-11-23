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
import { RulesetPicker } from './RulesetPicker';
import {
  SchematronRulesetKey,
  SCHEMATRON_RULESETS,
} from '@asap/shared/domain/schematron';

const DocumentValidator = ({
  documentType,
  rulesetKey,
}: {
  documentType: OscalDocumentKey;
  rulesetKey: SchematronRulesetKey;
}) => (
  <>
    <div className="grid-row tablet:padding-top-5">
      <div className="tablet:grid-col-4">
        <div className="position-sticky top-1 height-viewport overflow-y-auto">
          <ValidatorResultsFilterForm
            documentType={documentType}
            rulesetKey={rulesetKey}
          />
        </div>
      </div>
      <div className="tablet:grid-col-8 tablet:padding-left-2">
        <ValidatorReport documentType={documentType} rulesetKey={rulesetKey} />
      </div>
    </div>
  </>
);

export const ValidatorPage = ({
  documentType,
  rulesetKey,
}: {
  documentType: OscalDocumentKey | null;
  rulesetKey: SchematronRulesetKey;
}) => {
  const { router, rulesets } = useAppContext().state;
  const ruleset = rulesets[rulesetKey];
  return (
    <>
      <HeadingOne
        heading="FedRAMP OSCAL Document Rules"
        secondaryText="Browse FedRAMP OSCAL validation rules and
          apply them to your own documents"
      />

      <nav
        aria-label="Secondary navigation"
        className="desktop:display-block border-base-light border-bottom-1px"
      >
        <div className="grid-container grid-row flex-justify secondary-nav-container">
          <RulesetPicker />
          <a
            className={classnames('padding-2', {
              'active-link': router.currentRoute.type === 'DocumentSummary',
            })}
            href={getUrl(Routes.documentSummary(rulesetKey))}
          >
            Summary
          </a>
          <a
            className={classnames('padding-2', {
              'active-link': router.currentRoute.type === 'DocumentPOAM',
            })}
            href={getUrl(Routes.documentPOAM(rulesetKey))}
          >
            Plan of Action and Milestones
            {ruleset.validationResults.poam.current === 'HAS_RESULT' && (
              <span className="usa-tag margin-left-1 bg-theme-red">
                {ruleset.validationResults.poam.summary.firedCount}
              </span>
            )}
          </a>
          <a
            className={classnames('padding-2', {
              'active-link': router.currentRoute.type === 'DocumentSAP',
            })}
            href={getUrl(Routes.documentSAP(rulesetKey))}
          >
            Security Assessment Plan
            {ruleset.validationResults.sap.current === 'HAS_RESULT' && (
              <span className="usa-tag margin-left-1 bg-theme-red">
                {ruleset.validationResults.sap.summary.firedCount}
              </span>
            )}
          </a>
          <a
            className={classnames('padding-2', {
              'active-link': router.currentRoute.type === 'DocumentSAR',
            })}
            href={getUrl(Routes.documentSAR(rulesetKey))}
          >
            Security Assessment Report
            {ruleset.validationResults.sar.current === 'HAS_RESULT' && (
              <span className="usa-tag margin-left-1 bg-theme-red">
                {ruleset.validationResults.sar.summary.firedCount}
              </span>
            )}
          </a>
          <a
            className={classnames('padding-2', {
              'active-link': router.currentRoute.type === 'DocumentSSP',
            })}
            href={getUrl(Routes.documentSSP(rulesetKey))}
          >
            System Security Plan
            {ruleset.validationResults.ssp.current === 'HAS_RESULT' && (
              <span className="usa-tag margin-left-1 bg-theme-red">
                {ruleset.validationResults.ssp.summary.firedCount}
              </span>
            )}
          </a>
        </div>
      </nav>
      {ruleset.meta.description && (
        <div className="grid-container">
          <div className="usa-alert usa-alert--info usa-alert--slim">
            <div className="usa-alert__body">
              <p className="usa-alert__text">{ruleset.meta.description}</p>
            </div>
          </div>
        </div>
      )}
      <div className="grid-container">
        <div className="grid-row grid-gap margin-bottom-5">
          <div className="tablet:grid-col-12">
            <h1 className="font-sans-2xl text-light text-theme-dark-blue">
              Choose an XML file to process
            </h1>
          </div>
          <ValidatorFileSelectForm rulesetKey={rulesetKey} />
        </div>

        {documentType ? (
          <DocumentValidator
            documentType={documentType}
            rulesetKey={rulesetKey}
          />
        ) : (
          <div className="grid-row grid-gap">
            <div className="desktop:grid-col">
              <h2 className="font-sans-2xl text-light text-theme-dark-blue margin-0">
                {ruleset.meta.title} Summary
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
                      <a href={getUrl(Routes.documentSSP(rulesetKey))}>
                        System Security Plan
                      </a>
                    </td>
                    <td
                      className={classnames({
                        'text-success':
                          ruleset.validationResults.ssp.summary.firedCount ===
                          (0 || null),
                        'text-error':
                          ruleset.validationResults.ssp.summary.firedCount !==
                            null &&
                          ruleset.validationResults.ssp.summary.firedCount > 0,
                      })}
                    >
                      <b>
                        {ruleset.validationResults.ssp.summary.firedCount !==
                          null &&
                        ruleset.validationResults.ssp.summary.firedCount > 0
                          ? 'FAIL'
                          : 'PASS'}
                      </b>
                    </td>
                    <td>
                      {
                        ruleset.oscalDocuments.ssp.config.schematronAsserts
                          .length
                      }
                    </td>
                    <td>{ruleset.validationResults.ssp.summary.firedCount}</td>
                  </tr>
                  <tr>
                    <td>
                      <a href={getUrl(Routes.documentSAR(rulesetKey))}>
                        Security Assessment Report
                      </a>
                    </td>
                    <td>
                      <b
                        className={classnames({
                          'text-success':
                            ruleset.validationResults.sar.summary.firedCount ===
                            (0 || null),
                          'text-error':
                            ruleset.validationResults.sar.summary.firedCount !==
                              null &&
                            ruleset.validationResults.sar.summary.firedCount >
                              0,
                        })}
                      >
                        {ruleset.validationResults.sar.summary.firedCount !==
                          null &&
                        ruleset.validationResults.sar.summary.firedCount > 0
                          ? 'FAIL'
                          : 'PASS'}
                      </b>
                    </td>
                    <td>
                      {
                        ruleset.oscalDocuments.sar.config.schematronAsserts
                          .length
                      }
                    </td>
                    <td>{ruleset.validationResults.sar.summary.firedCount}</td>
                  </tr>
                  <tr>
                    <td>
                      <a href={getUrl(Routes.documentSAP(rulesetKey))}>
                        Security Assessment Plan
                      </a>
                    </td>
                    <td
                      className={classnames({
                        'text-success':
                          ruleset.validationResults.sap.summary.firedCount ===
                          (0 || null),
                        'text-error':
                          ruleset.validationResults.sap.summary.firedCount !==
                            null &&
                          ruleset.validationResults.sap.summary.firedCount > 0,
                      })}
                    >
                      <b>
                        {ruleset.validationResults.sap.summary.firedCount !==
                          null &&
                        ruleset.validationResults.sap.summary.firedCount > 0
                          ? 'FAIL'
                          : 'PASS'}
                      </b>
                    </td>
                    <td>
                      {
                        ruleset.oscalDocuments.sap.config.schematronAsserts
                          .length
                      }
                    </td>
                    <td>{ruleset.validationResults.sap.summary.firedCount}</td>
                  </tr>
                  <tr>
                    <td>
                      <a href={getUrl(Routes.documentPOAM(rulesetKey))}>
                        Plan of Action and Milestones
                      </a>
                    </td>
                    <td
                      className={classnames({
                        'text-success':
                          ruleset.validationResults.poam.summary.firedCount ===
                          (0 || null),
                        'text-error':
                          ruleset.validationResults.poam.summary.firedCount !==
                            null &&
                          ruleset.validationResults.poam.summary.firedCount > 0,
                      })}
                    >
                      <b>
                        {ruleset.validationResults.poam.summary.firedCount !==
                          null &&
                        ruleset.validationResults.poam.summary.firedCount > 0
                          ? 'FAIL'
                          : 'PASS'}
                      </b>
                    </td>
                    <td>
                      {
                        ruleset.oscalDocuments.poam.config.schematronAsserts
                          .length
                      }
                    </td>
                    <td>{ruleset.validationResults.poam.summary.firedCount}</td>
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
