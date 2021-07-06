import React from 'react';

import { useAppState } from '../hooks';

export const Breadcrumbs = () => {
  const breadcrumbs = useAppState().breadcrumbs;

  return (
    <nav className="usa-breadcrumb" aria-label="Breadcrumbs">
      <ol className="usa-breadcrumb__list">
        {breadcrumbs.map(breadcrumb => {
          const contentNode = <span>{breadcrumb.text}</span>;
          return (
            <li
              className="usa-breadcrumb__list-item"
              aria-current={breadcrumb.selected && 'page'}
            >
              {breadcrumb.selected ? (
                contentNode
              ) : (
                <a href={breadcrumb.url} className="usa-breadcrumb__link">
                  {contentNode}
                </a>
              )}
            </li>
          );
        })}
      </ol>
    </nav>
  );
};
