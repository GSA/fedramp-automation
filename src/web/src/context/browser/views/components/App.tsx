import React from 'react';
import { Banner } from './Banner';
import { Footer } from './Footer';
import { Header } from './Header';
import { SSPValidator } from './SSPValidator';

interface AppProps {}

export const App = () => {
  return (
    <div>
      <Banner />
      <Header />
      <div className="grid-container">
        <SSPValidator />
      </div>
      <Footer />
    </div>
  );
};
