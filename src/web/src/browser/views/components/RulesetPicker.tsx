import { useAppContext } from '../context';
import '../styles/RulesetPicker.scss';
import { SchematronRulesetKey } from '@asap/shared/domain/schematron';
import { setCurrentRoute } from '@asap/browser/presenter/actions';
import { getUrl, Routes } from '@asap/browser/presenter/state/router';

export const RulesetPicker = () => {
  const { dispatch, state } = useAppContext();
  return (
    <section className="ruleset-picker">
      <div className="grid-container">
        <div className="grid-col-auto">
          <span className="usa-accordion">
            <select
              className="usa-select margin-right-105 border-0 padding-top-0 padding-bottom-0 margin-top-0"
              name="schematron-ruleset"
              id="schematron-ruleset"
              disabled={state.validator.current === 'PROCESSING'}
              onChange={event => {
                dispatch(
                  setCurrentRoute(
                    getUrl(
                      Routes.documentSummary(
                        event.target.options[event.target.selectedIndex]
                          .value as SchematronRulesetKey,
                      ),
                    ),
                  ),
                );
              }}
            >
              {Object.entries(state.validator.ruleset.choices).map(
                ([rulesetKey, ruleset], index) => (
                  <option key={index} value={rulesetKey}>
                    {ruleset.title}
                  </option>
                ),
              )}
            </select>
          </span>
        </div>
      </div>
    </section>
  );
};
