import React from 'react';
import { Breadcrumbs } from './Breadcrumbs';

type Props = {
  children?: JSX.Element;
};

export const InnerPageLayout = ({ children }: Props) => (
  <>
    <Breadcrumbs />
    {children}
  </>
);
