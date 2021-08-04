import React from 'react';
import { useAppState } from '../hooks';
import { Banner } from './Banner';
import { Footer } from './Footer';
import { Header } from './Header';
import { HomePage } from './HomePage';
import { InnerPageLayout } from './InnerPageLayout';
import { SummaryPage } from './SummaryPage';
import { ValidatorPage } from './ValidatorPage';
import { ViewerPage } from './ViewerPage';

const CurrentPage = () => {
  const { currentRoute } = useAppState().router;
  if (currentRoute.type === 'Home') {
    return <HomePage />;
  } else if (currentRoute.type === 'Validator') {
    return (
      <InnerPageLayout>
        <ValidatorPage />
      </InnerPageLayout>
    );
  } else if (currentRoute.type === 'Summary') {
    return (
      <InnerPageLayout>
        <SummaryPage />
      </InnerPageLayout>
    );
  } else if (currentRoute.type === 'Assertion') {
    return (
      <InnerPageLayout>
        <ViewerPage assertionId={currentRoute.assertionId} />
      </InnerPageLayout>
    );
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
        <CurrentPage />
      </div>
      <Footer />
    </div>
  );
};
