import { useAppContext } from '../context';
import { HeadingOne } from './HeadingOne';
import laptopImage from '../images/laptop.svg';

export const DevelopersPage = () => {
  const { developerExampleUrl } = useAppContext().state.config.sourceRepository;
  return (
    <>
      <HeadingOne heading="Developers" />
      <div className="grid-container">
        <div className="grid-row grid-gap">
          <div className="desktop:grid-col">
            <h2 className="font-sans-2xl text-light text-theme-dark-blue margin-bottom-5">
              Evaluate the Rules
            </h2>
            <img
              src={laptopImage}
              alt="laptop, notepad, markers, and papers on a desk."
            />
          </div>
          <div className="desktop:grid-col tablet:padding-top-8">
            <div className="usa-prose">
              <p className="font-sans-md">
                As a third-party developer, you may evaluate the FedRAMP ASAP
                rules with an XSLT 3.0 processor.
              </p>
              <p>
                Developer examples are available in our{' '}
                <a
                  className="text-underline text-primary"
                  href={developerExampleUrl}
                >
                  Github repository
                </a>
                .
              </p>
            </div>
          </div>
        </div>
      </div>
    </>
  );
};
