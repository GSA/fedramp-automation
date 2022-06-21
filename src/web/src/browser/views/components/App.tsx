import React from 'react';

import type { OscalDocumentKey } from '@asap/shared/domain/oscal';

import { useAppState } from '../hooks';

import { AssertionDocumentationOverlay } from './AssertionDocumentationOverlay';
import { DocumentViewerOverlay } from './DocumentViewerOverlay';
import { BetaBanner } from './BetaBanner';
import { DevelopersPage } from './DevelopersPage';
import { Footer } from './Footer';
import { Header } from './Header';
import { HomePage } from './HomePage';
import { InnerPageLayout } from './InnerPageLayout';
import { UsaBanner } from './UsaBanner';
import { UsageTrackingPage } from './UsageTrackingPage';
import { ValidatorPage } from './ValidatorPage';

const CurrentPage = () => {
  const { currentRoute } = useAppState().router;
  if (currentRoute.type === 'Home') {
    return (
      <div className="grid-container">
        <HomePage />
      </div>
    );
  } else if (
    currentRoute.type === 'DocumentSummary' ||
    currentRoute.type === 'DocumentPOAM' ||
    currentRoute.type === 'DocumentSAP' ||
    currentRoute.type === 'DocumentSAR' ||
    currentRoute.type === 'DocumentSSP'
  ) {
    const documentType = {
      DocumentSummary: null,
      DocumentPOAM: 'poam',
      DocumentSAP: 'sap',
      DocumentSAR: 'sar',
      DocumentSSP: 'ssp',
    }[currentRoute.type] as OscalDocumentKey | null;
    return (
      <>
        <InnerPageLayout>
          <ValidatorPage documentType={documentType} />
        </InnerPageLayout>
        <AssertionDocumentationOverlay />
        {documentType ? (
          <DocumentViewerOverlay documentType={documentType} />
        ) : null}
      </>
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
