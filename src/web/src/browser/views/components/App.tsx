import React from 'react';
import { useAppState } from '../hooks';
import { Banner } from './Banner';
import { Breadcrumbs } from './Breadcrumbs';
import { Footer } from './Footer';
import { Header } from './Header';
import { SummaryPage } from './SummaryPage';
import { ValidatorPage } from './ValidatorPage';
import { ViewerPage } from './ViewerPage';
import { WelcomePage } from './WelcomePage';

const CurrentPage = () => {
  const { currentRoute } = useAppState().router;
  if (currentRoute.type === 'Home') {
    return (
      <div>
        <WelcomePage />
      </div>
    );
  } else if (currentRoute.type === 'Validator') {
    return <ValidatorPage />;
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
