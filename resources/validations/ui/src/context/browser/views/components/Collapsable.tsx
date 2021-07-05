import React from 'react';

type CollapsableProps = {
  children?: React.ReactNode;
  title: string;
};

export const Collapsable = ({ children, title }: CollapsableProps) => {
  return (
    <div className="usa-accordion">
      {React.Children.map(children, (child, index) => (
        <>
          <h4 className="usa-accordion__heading">
            <button
              className="usa-accordion__button"
              aria-expanded="false"
              aria-controls={`id-${index}`}
            >
              {title}
            </button>
          </h4>
          <div
            id={`id-${index}`}
            className="usa-accordion__content usa-prose"
            style={{ maxHeight: '30em' }}
          >
            {child}
          </div>
        </>
      ))}
    </div>
  );
};
