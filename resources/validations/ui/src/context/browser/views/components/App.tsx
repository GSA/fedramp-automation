import React from 'react';
import { useAppState } from '../hooks';
import { Banner } from './Banner';
import { Breadcrumbs } from './Breadcrumbs';
import { Footer } from './Footer';
import { Header } from './Header';
import { HomePage } from './HomePage';
import { ViewerPage } from './ViewerPage';

const CurrentPage = () => {
  const { currentRoute } = useAppState();
  if (currentRoute.type === 'Home') {
    return <HomePage />;
  } else if (currentRoute.type === 'Viewer') {
    return <ViewerPage />;
  } else if (currentRoute.type === 'AssertionList') {
    return <div>TODO: AssertionList page</div>;
  } else if (currentRoute.type === 'Assertion') {
    return <div>TODO: Assertion page</div>;
  } else {
    const _exhaustiveCheck: never = currentRoute;
    return <></>;
  }
};

export const App = () => {
  return (
    <div>
      <Banner />
      <Header />
      <div className="grid-container">
        <Breadcrumbs />
        <CurrentPage />
      </div>
      <Footer />
    </div>
  );
};
