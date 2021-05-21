import React from 'react';
import Banner from './Banner';
import Header from './Header';
import SSPValidator from './SSPValidator';

interface AppProps {}

function App({}: AppProps) {
  return (
    <>
      <Banner />
      <Header />
      <div className="grid-container">
        <div className="grid-row">
          <div className="tablet:grid-col">
            <SSPValidator />
          </div>
        </div>
      </div>
    </>
  );
}

export default App;
