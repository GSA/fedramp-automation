import { useAppContext } from '../context';

export const Breadcrumbs = () => {
  const { breadcrumbs } = useAppContext().state.router;

  return (
    <nav className="usa-breadcrumb" aria-label="Breadcrumbs">
      <ol className="usa-breadcrumb__list">
        {breadcrumbs.map((breadcrumb, index) => {
          const contentNode = <span>{breadcrumb.text}</span>;
          return (
            <li
              key={index}
              className="usa-breadcrumb__list-item"
              aria-current={!breadcrumb.linkUrl && 'page'}
            >
              {breadcrumb.linkUrl ? (
                <a href={breadcrumb.linkUrl} className="usa-breadcrumb__link">
                  {contentNode}
                </a>
              ) : (
                contentNode
              )}
            </li>
          );
        })}
      </ol>
    </nav>
  );
};
