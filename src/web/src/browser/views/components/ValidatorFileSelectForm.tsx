import spriteSvg from 'uswds/img/sprite.svg';

import { onFileInputChangeGetFile } from '../../util/file-input';
import * as validator from '../../presenter/actions/validator';
import { useAppContext } from '../context';

export const ValidatorFileSelectForm = () => {
  const { dispatch, state } = useAppContext();

  return (
    <>
      <div className="tablet:grid-col-4">
        <div className="usa-hint" id="file-input-specific-hint">
          Select FedRAMP OSCAL XML or JSON file (SSP, SAP, SAR, or POA&M)
        </div>
        <input
          id="file-input-specific"
          className="usa-file-input"
          type="file"
          name="file-input-specific"
          aria-describedby="file-input-specific-hint"
          accept=".xml,.json"
          onChange={onFileInputChangeGetFile(fileDetails => {
            dispatch(
              validator.validateOscalDocument({
                fileName: fileDetails.name,
                fileContents: fileDetails.text,
              }),
            );
          })}
          disabled={state.validator.current === 'PROCESSING'}
        />
      </div>
      <div className="tablet:grid-col-8">
        <label
          className="usa-label usa-hint margin-top-0"
          htmlFor="sample-document"
        >
          Or use an example file, brought to you by FedRAMP:
        </label>
        {state.validator.current === 'PROCESSING_ERROR' && (
          <div className="usa-alert usa-alert--error" role="alert">
            <div className="usa-alert__body">
              <h4 className="usa-alert__heading">Processing Error</h4>
              <p className="usa-alert__text">{state.validator.errorMessage}</p>
            </div>
          </div>
        )}
        <div className="margin-top-3 display-flex flex-align-center">
          <select
            className="usa-select margin-right-105"
            name="sample-document"
            id="sample-document"
            disabled={state.validator.current === 'PROCESSING'}
            onChange={event => {
              window.requestAnimationFrame(() =>
                dispatch(
                  validator.setXmlUrl(
                    event.target.options[event.target.selectedIndex].value,
                  ),
                ),
              );
            }}
          >
            <option value="">--Select--</option>
            {state.config.sourceRepository.sampleDocuments.map(
              (sampleDocument, index) => (
                <option
                  key={index}
                  onSelect={() =>
                    dispatch(validator.setXmlUrl(sampleDocument.url))
                  }
                  value={sampleDocument.url}
                >
                  {sampleDocument.displayName}
                </option>
              ),
            )}
          </select>
          {state.validator.current === 'UNLOADED' && (
            <svg
              className="usa-icon text-info-lighter font-sans-xl"
              aria-hidden="true"
              focusable="false"
              role="img"
            >
              <use xlinkHref={`${spriteSvg}#radio_button_unchecked`}></use>
            </svg>
          )}
          {state.validator.current === 'PROCESSING' && (
            <div className="loader" />
          )}
          {state.validator.current === 'PROCESSING_ERROR' && (
            <svg
              className="usa-icon text-error font-sans-xl "
              aria-hidden="true"
              focusable="false"
              role="img"
            >
              <use xlinkHref={`${spriteSvg}#error`}></use>
            </svg>
          )}
          {state.validator.current === 'VALIDATED' && (
            <svg
              className="usa-icon text-success font-sans-xl"
              aria-hidden="true"
              focusable="false"
              role="img"
            >
              <use xlinkHref={`${spriteSvg}#check_circle`}></use>
            </svg>
          )}
        </div>
        {state.validator.current === 'PROCESSING' && (
          <div className="z-top usa-hint loader-message">
            <div className="loader-message-text">
              Please wait, this document is still processing...
            </div>
          </div>
        )}
      </div>
    </>
  );
};
