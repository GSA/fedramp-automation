import React from 'react';
import Banner from './Banner';
import Header from './Header';
import XslSchematronValidator from './XslSchematronValidator';

interface AppProps {}

function App({}: AppProps) {
  return (
    <>
      <Banner />
      <Header />
      <div className="grid-container">
        <div className="grid-row">
          <div className="tablet:grid-col">
            <XslSchematronValidator />
          </div>
        </div>
      </div>
    </>
  );
}

export default App;
