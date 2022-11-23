import { SchematronRulesetKey } from '@asap/shared/domain/schematron';
import { setCurrentRoute } from '@asap/browser/presenter/actions';
import { getUrl, Routes } from '@asap/browser/presenter/state/router';

import { useAppContext } from '../context';
import '../styles/RulesetPicker.scss';

export const RulesetPicker = () => {
  const { dispatch, state } = useAppContext();
  return (
    <section className="ruleset-picker padding-2 tablet:padding-0">
      <select
        className="usa-select margin-right-105 border-0 padding-top-0 padding-bottom-0 padding-left-0 tablet:padding-left-2 margin-top-0"
        name="schematron-ruleset"
        id="schematron-ruleset"
        disabled={state.validator.current === 'PROCESSING'}
        defaultValue={(state.router.currentRoute as any).ruleset}
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
    </section>
  );
};
