import React from 'react';

type Props = {
  children?: JSX.Element;
};
export const ContentOverlay = ({ children }: Props) => {
  return (
    <div className="position-fixed z-top top-0 left-0 bottom-0 right-0 bg-white">
      <div className="position-fixed">
        <div className="overflow-y-scroll">{children}</div>
      </div>
    </div>
  );
};
