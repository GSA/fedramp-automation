type Props = {
  children?: JSX.Element;
};

export const InnerPageLayout = ({ children }: Props) => (
  <div className="grid-container">{children}</div>
);
