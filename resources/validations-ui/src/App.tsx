import React from 'react';
import Banner from './components/Banner';
import Header from './components/Header';

interface AppProps {}

function App({}: AppProps) {
  return <>
    <Banner />
    <Header />
  </>;
}

export default App;
