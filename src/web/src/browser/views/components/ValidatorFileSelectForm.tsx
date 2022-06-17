import spriteSvg from 'uswds/img/sprite.svg';

import { onFileInputChangeGetFile } from '../../util/file-input';
import { useActions, useAppState } from '../hooks';

export const ValidatorFileSelectForm = () => {
  const actions = useActions();
  const state = useAppState();

  const sourceRepository = state.sourceRepository;

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
            actions.validator.validateOscalDocument({
              fileName: fileDetails.name,
              fileContents: fileDetails.text,
            });
          })}
          disabled={
            state.newAppContext.state.validator.current === 'PROCESSING'
          }
        />
      </div>
      <div className="tablet:grid-col-8">
        {state.newAppContext.state.validator.current === 'UNLOADED' && (
          <svg
            className="usa-icon text-info-lighter font-sans-xl float-right"
            aria-hidden="true"
            focusable="false"
            role="img"
          >
            <use xlinkHref={`${spriteSvg}#radio_button_unchecked`}></use>
          </svg>
        )}
        {state.newAppContext.state.validator.current === 'PROCESSING' && (
          <div className="loader float-right" />
        )}
        {state.newAppContext.state.validator.current === 'PROCESSING_ERROR' && (
          <svg
            className="usa-icon text-error font-sans-xl float-right"
            aria-hidden="true"
            focusable="false"
            role="img"
          >
            <use xlinkHref={`${spriteSvg}#error`}></use>
          </svg>
        )}
        {state.newAppContext.state.validator.current === 'VALIDATED' && (
          <svg
            className="usa-icon text-primary-vivid font-sans-xl float-right"
            aria-hidden="true"
            focusable="false"
            role="img"
          >
            <use xlinkHref={`${spriteSvg}#check_circle`}></use>
          </svg>
        )}
        <label className="usa-label usa-hint" htmlFor="sample-document">
          Or use an example file, brought to you by FedRAMP:
        </label>
        <select
          className="usa-select"
          name="sample-document"
          id="sample-document"
          disabled={
            state.newAppContext.state.validator.current === 'PROCESSING'
          }
          onChange={event => {
            window.requestAnimationFrame(() =>
              actions.validator.setXmlUrl(
                event.target.options[event.target.selectedIndex].value,
              ),
            );
          }}
        >
          <option value=""></option>
          {sourceRepository.sampleDocuments.map((sampleDocument, index) => (
            <option
              key={index}
              onSelect={() => actions.validator.setXmlUrl(sampleDocument.url)}
              value={sampleDocument.url}
            >
              {sampleDocument.displayName}
            </option>
          ))}
        </select>
        {state.newAppContext.state.validator.current === 'PROCESSING_ERROR' && (
          <div className="usa-alert usa-alert--error" role="alert">
            <div className="usa-alert__body">
              <h4 className="usa-alert__heading">Processing Error</h4>
              <p className="usa-alert__text">
                {state.newAppContext.state.validator.errorMessage}
              </p>
            </div>
          </div>
        )}
      </div>
    </>
  );
};
