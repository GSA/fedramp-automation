import React from 'react';
import { useAppState } from '../hooks';
import { Banner } from './Banner';
import { Breadcrumbs } from './Breadcrumbs';
import { Footer } from './Footer';
import { Header } from './Header';
import { HomePage } from './HomePage';
import { SchematronPage } from './SchematronPage';
import { SummaryPage } from './SummaryPage';
import { ViewerPage } from './ViewerPage';

const CurrentPage = () => {
  const { currentRoute } = useAppState();
  if (currentRoute.type === 'Home') {
    return <HomePage />;
  } else if (currentRoute.type === 'Summary') {
    return <SummaryPage />;
  } else if (currentRoute.type === 'Assertion') {
    return <ViewerPage assertionId={currentRoute.assertionId} />;
  } else if (currentRoute.type === 'Schematron') {
    return <SchematronPage />;
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
        <a href="#/schematron">Schematron test page</a>
        <CurrentPage />
      </div>
      <Footer />
    </div>
  );
};
