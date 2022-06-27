type HeadingOneProps = {
  children?: React.ReactNode;
  heading: string;
  secondaryText?: string;
};

export const HeadingOne = ({ heading, secondaryText }: HeadingOneProps) => {
  return (
    <div className="padding-y-5 text-white text-center bg-primary-dark">
      <h1 className="font-sans-2xl line-height-heading-1 text-light">
        {heading.toUpperCase()}
      </h1>
      {secondaryText && <p>{secondaryText}</p>}
    </div>
  );
};
