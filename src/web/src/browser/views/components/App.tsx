import React from 'react';

import { useAppState } from '../hooks';
import { BetaBanner } from './BetaBanner';
import { DevelopersPage } from './DevelopersPage';
import { Footer } from './Footer';
import { Header } from './Header';
import { HomePage } from './HomePage';
import { InnerPageLayout } from './InnerPageLayout';
import { SummaryPage } from './SummaryPage';
import { UsaBanner } from './UsaBanner';
import { UsageTrackingPage } from './UsageTrackingPage';
import { ValidatorContentOverlay } from './ValidatorContentOverlay';
import { ValidatorPage } from './ValidatorPage';
import { ViewerPage } from './ViewerPage';

const CurrentPage = () => {
  const { currentRoute } = useAppState().router;
  if (currentRoute.type === 'Home') {
    return <HomePage />;
  } else if (currentRoute.type === 'Validator') {
    return (
      <>
        <InnerPageLayout>
          <ValidatorPage />
        </InnerPageLayout>
        <ValidatorContentOverlay />
      </>
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
  } else if (currentRoute.type === 'Developers') {
    return (
      <InnerPageLayout>
        <DevelopersPage />
      </InnerPageLayout>
    );
  } else if (currentRoute.type === 'UsageTracking') {
    return (
      <InnerPageLayout>
        <UsageTrackingPage />
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
      <BetaBanner />
      <UsaBanner />
      <Header />
      <CurrentPage />
      <Footer />
    </div>
  );
};
