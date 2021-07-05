import React from 'react';

import { useActions, useAppState } from '../hooks';

export const Breadcrumbs = () => {
  const BreadcrumbItem = (props: {
    url: string;
    text: string;
    selected: boolean;
  }) => {
    const contentNode = <span>{props.text}</span>;
    return (
      <li
        className="usa-breadcrumb__list-item"
        aria-current={props.selected && 'page'}
      >
        {props.selected ? (
          contentNode
        ) : (
          <a href={props.url} className="usa-breadcrumb__link">
            {contentNode}
          </a>
        )}
      </li>
    );
  };

  return (
    <nav className="usa-breadcrumb" aria-label="Breadcrumbs">
      <ol className="usa-breadcrumb__list">
        <BreadcrumbItem url="/" text="Home" selected={true} />
        <BreadcrumbItem url="/" text="Viewer" selected={false} />
      </ol>
    </nav>
  );
};
