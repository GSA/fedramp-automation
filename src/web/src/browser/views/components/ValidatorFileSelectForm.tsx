import React from 'react';

import { onFileInputChangeGetFile } from '../../util/file-input';
import { useActions, useAppState } from '../hooks';

export const ValidatorFileSelectForm = () => {
  const { sourceRepository, schematron } = useAppState();
  const actions = useActions();
  return (
    <>
      <div className="tablet:grid-col-4">
        <div className="usa-hint" id="file-input-specific-hint">
          Select FedRAMP OSCAL SSP XML or JSON file
        </div>
        <input
          id="file-input-specific"
          className="usa-file-input"
          type="file"
          name="file-input-specific"
          aria-describedby="file-input-specific-hint"
          accept=".xml,.json"
          onChange={onFileInputChangeGetFile(fileDetails => {
            actions.validator.setSspFile({
              fileName: fileDetails.name,
              fileContents: fileDetails.text,
            });
          })}
          disabled={schematron.validator.current === 'PROCESSING'}
        />
      </div>
      <div className="tablet:grid-col-8">
        {schematron.validator.current === 'UNLOADED' && (
          <svg
            className="usa-icon text-info-lighter font-sans-xl float-right"
            aria-hidden="true"
            focusable="false"
            role="img"
          >
            <use
              xlinkHref={actions.getAssetUrl(
                'uswds/img/sprite.svg#radio_button_unchecked',
              )}
            ></use>
          </svg>
        )}
        {schematron.validator.current === 'PROCESSING' && (
          <div className="loader float-right" />
        )}
        {schematron.validator.current === 'PROCESSING_ERROR' && (
          <svg
            className="usa-icon text-error font-sans-xl float-right"
            aria-hidden="true"
            focusable="false"
            role="img"
          >
            <use
              xlinkHref={actions.getAssetUrl('uswds/img/sprite.svg#error')}
            ></use>
          </svg>
        )}
        {schematron.validator.current === 'VALIDATED' && (
          <svg
            className="usa-icon text-primary-vivid font-sans-xl float-right"
            aria-hidden="true"
            focusable="false"
            role="img"
          >
            <use
              xlinkHref={actions.getAssetUrl(
                'uswds/img/sprite.svg#check_circle',
              )}
            ></use>
          </svg>
        )}
        <div className="usa-hint">
          Or use an example file, brought to you by FedRAMP:
        </div>
        <ul className="usa-icon-list margin-top-2">
          {sourceRepository.sampleSSPs.map((sampleSSP, index) => (
            <li key={index} className="usa-icon-list__item">
              <div className="usa-icon-list__icon text-primary">
                <svg className="usa-icon" aria-hidden="true" role="img">
                  <use
                    xlinkHref={actions.getAssetUrl(
                      'uswds/img/sprite.svg#upload_file',
                    )}
                  ></use>
                </svg>
              </div>
              <div className="usa-icon-list__content">
                <button
                  className="usa-button usa-button--unstyled"
                  onClick={() => actions.validator.setXmlUrl(sampleSSP.url)}
                  disabled={schematron.validator.current === 'PROCESSING'}
                >
                  {sampleSSP.displayName}
                </button>
              </div>
            </li>
          ))}
        </ul>
        {schematron.validator.current === 'PROCESSING_ERROR' && (
          <div className="usa-alert usa-alert--error" role="alert">
            <div className="usa-alert__body">
              <h4 className="usa-alert__heading">Processing Error</h4>
              <p className="usa-alert__text">
                {schematron.validator.errorMessage}
              </p>
            </div>
          </div>
        )}
      </div>
    </>
  );
};
