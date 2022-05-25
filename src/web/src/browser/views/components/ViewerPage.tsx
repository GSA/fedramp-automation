import React, { createRef, useEffect } from 'react';

import { useAppState } from '../hooks';
import { CodeViewer } from './CodeViewer';

type ViewerProps = {
  assertionId?: string;
};

export const ViewerPage = (props: ViewerProps) => {
  const oscalDocuments = useAppState().oscalDocuments;
  let ref = createRef<HTMLDivElement>();

  useEffect(() => {
    /*if (ref.current && props.assertionId) {
      const target = ref.current.querySelector(`#${props.assertionId}`);
      if (target && target.parentNode) {
        (target.parentNode as any).scrollTop = (target as any).offsetTop;
      }
    }*/
    if (ref.current && props.assertionId) {
      const target = ref.current.querySelector(
        `#${props.assertionId}`,
      ) as HTMLElement;
      if (target) {
        target.scrollIntoView({
          behavior: 'auto',
          block: 'start',
          inline: 'start',
        });
        target.style.backgroundColor = 'lightgray';
      }
    }
  });

  return (
    <div className="grid-row grid-gap">
      <div ref={ref} className="mobile:grid-col-12">
        {oscalDocuments.ssp.validationResults.current === 'HAS_RESULT' ? (
          <CodeViewer
            codeHTML={oscalDocuments.ssp.validationResults.annotatedXML}
          />
        ) : (
          <p>No report validated.</p>
        )}
      </div>
    </div>
  );
};
