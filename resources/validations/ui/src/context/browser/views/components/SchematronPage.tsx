import React from 'react';
import { useActions, useAppState } from '../hooks';

type RuleListItemProps = {
  iconUrl: string;
  iconColor: string;
  title: string;
  text: string;
};
const RuleListItem = (props: RuleListItemProps) => (
  <li className="usa-icon-list__item">
    <div className={`usa-icon-list__icon text-${props.iconColor}`}>
      <svg className="usa-icon" aria-hidden="true" role="img">
        <use xlinkHref={props.iconUrl}></use>
      </svg>
    </div>
    <div className="usa-icon-list__content">
      <h3 className="usa-icon-list__title">{props.title}</h3>
      <p>{props.text}</p>
    </div>
  </li>
);

const SampleGarbage = () => {
  const { getAssetUrl } = useActions();
  return (
    <ul className="usa-icon-list usa-icon-list--size-lg">
      <li className="usa-icon-list__item">
        <div className={`usa-icon-list__icon text-green`}>
          <svg className="usa-icon" aria-hidden="true" role="img">
            <use
              xlinkHref={getAssetUrl('uswds/img/sprite.svg#check_circle')}
            ></use>
          </svg>
        </div>
        <div className="usa-icon-list__content">
          <h3 className="usa-icon-list__title">Section heading</h3>
          <p>
            <span className={`text-green`}>
              <svg className="usa-icon" aria-hidden="true" role="img">
                <use
                  xlinkHref={getAssetUrl('uswds/img/sprite.svg#check_circle')}
                ></use>
              </svg>
            </span>
            Test text test text
          </p>
        </div>
      </li>
    </ul>
  );
};

export const SchematronPage = () => {
  const { sspSchematron } = useAppState();
  const { getAssetUrl } = useActions();
  return (
    <div className="grid-row grid-gap">
      <div className="tablet:grid-col">
        <h3 className="site-preview-heading border-top-1px border-base-light padding-top-1">
          Validation Rules
        </h3>
        <SampleGarbage />
        <ul className="usa-icon-list usa-icon-list--size-lg">
          <RuleListItem
            iconUrl={getAssetUrl('uswds/img/sprite.svg#cancel')}
            iconColor="red"
            title="Failed rule assertion"
            text="Example text."
          />
          <RuleListItem
            iconUrl={getAssetUrl('uswds/img/sprite.svg#help')}
            iconColor="blue"
            title="Unevaluated rule assertion"
            text="Example text."
          />
          {sspSchematron.patterns.map((pattern, i1) =>
            pattern.rules.map((rule, i2) =>
              rule.asserts.map((assert, i3) => (
                <RuleListItem
                  key={`${i1}-${i2}-${i3}`}
                  iconUrl={getAssetUrl('uswds/img/sprite.svg#check_circle')}
                  iconColor="green"
                  title={assert.message.toString()}
                  text={assert.id || ''}
                />
              )),
            ),
          )}
        </ul>
      </div>
      <ul>
        {sspSchematron.patterns.map((pattern, index) => (
          <li key={index}>
            <div>id: {pattern.id}</div>
            <ul>
              rules:{' '}
              {pattern.rules.map((rule, index) => (
                <li key={index}>
                  <ul>
                    {rule.asserts.map((assert, index) => (
                      <li key={index}>
                        <dl>
                          <dt>ID</dt>
                          <dd>{assert.id}</dd>
                          <dt>isReport</dt>
                          <dd>{assert.isReport ? 'Yes' : 'No'}</dd>
                          <dt>Message</dt>
                          <dd>
                            {assert.message.map(m => {
                              if (typeof m === 'string') {
                                return m;
                              } else {
                                return (
                                  <span
                                    className="bg-info-lighter"
                                    style={{ fontStyle: 'italic' }}
                                  >
                                    ${m.$type}(${m.select})
                                  </span>
                                );
                              }
                            })}
                          </dd>
                          <dt>Test</dt>
                          <dd>{assert.test}</dd>
                        </dl>
                      </li>
                    ))}
                  </ul>
                  <div>{rule.context}</div>
                  <ul>
                    {rule.variables.map((variable, index) => (
                      <li key={index}>
                        {variable.name} = {variable.value}
                      </li>
                    ))}
                  </ul>
                </li>
              ))}
            </ul>
            <ul>
              {pattern.variables.map((variable, index) => (
                <li key={index}>
                  {variable.name} = {variable.value}
                </li>
              ))}
            </ul>
          </li>
        ))}
      </ul>
    </div>
  );
};
