import { useAppContext } from '../context';
import * as validator from '../../presenter/actions/validator';
import '../styles/RulesetPicker.scss';
import { SchematronRulesetKey } from '@asap/shared/domain/schematron';

export const RulesetPicker = () => {
  const { dispatch, state } = useAppContext();
  return (
    <section className="ruleset-picker">
      <div className="grid-container">
        <div className="grid-col-auto">
          <span className="usa-accordion">
            <select
              className="usa-select margin-right-105"
              name="schematron-ruleset"
              id="schematron-ruleset"
              disabled={state.validator.current === 'PROCESSING'}
              onChange={event => {
                  dispatch(
                    validator.setSchematronRuleset(
                      event.target.options[event.target.selectedIndex].value as SchematronRulesetKey,
                    ),
                  );
              }}
            >
              {Object.entries(state.validator.ruleset.choices).map(
                ([rulesetKey, ruleset], index) => (
                  <option
                    key={index}
                    value={rulesetKey}
                  >
                    {ruleset.title}
                  </option>
                )
              )}
            </select>
          </span>
        </div>
      </div>
    </section>
  );
};
