import { useAppState } from '../hooks';

export const DevelopersPage = () => {
  const { developerExampleUrl } = useAppState().sourceRepository;
  return (
    <>
      <h1>Developers</h1>
      <div className="usa-prose">
        <p>
          As a third-party developer, you may evaluate the FedRAMP ASAP rules
          with an XSLT 3.0 processor.
        </p>
        <p>
          Developer examples are available in our{' '}
          <a href={developerExampleUrl}>Github repository</a>.
        </p>
      </div>
    </>
  );
};
