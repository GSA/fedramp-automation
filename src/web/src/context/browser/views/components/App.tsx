import React from 'react';
import { useAppState } from '../hooks';
import { Banner } from './Banner';
import { Breadcrumbs } from './Breadcrumbs';
import { Footer } from './Footer';
import { Header } from './Header';
import { HomePage } from './HomePage';
import { SchematronReport } from './SchematronReport';
import { SummaryPage } from './SummaryPage';
import { ViewerPage } from './ViewerPage';

const CurrentPage = () => {
  const { currentRoute } = useAppState();
  if (currentRoute.type === 'Home') {
    return (
      <div>
        <HomePage />
      </div>
    );
  } else if (currentRoute.type === 'Summary') {
    return <SummaryPage />;
  } else if (currentRoute.type === 'Assertion') {
    return <ViewerPage assertionId={currentRoute.assertionId} />;
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
