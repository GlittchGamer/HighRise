import './Flashbang.scss';

import React from 'react';
import { Fade } from '@mui/material';
import useData from '@/hooks/useData';
import { dispatchNUI } from '@/util/dispatchNUI';

type Props = {};

const Flashbang = (props: Props) => {
  const { ClientInfo } = useData();

  const [to, setTo] = React.useState<NodeJS.Timeout>(null);
  const [showing, setShowing] = React.useState(false);

  React.useEffect(() => {
    if (!!to) clearTimeout(to);
    if (Boolean(ClientInfo.flashbanged)) {
      if (!showing) {
        setShowing(true);
      } else {
        setTo(
          setTimeout(() => {
            setShowing(false);
          }, ClientInfo.flashbanged?.duration || 3000),
        );
      }
    } else {
      setShowing(false);
    }

    return () => {
      // if (Boolean(to)) clearTimeout(to);
      if (!!to) clearTimeout(to);
    };
  }, [ClientInfo.flashbanged]);

  const onEntered = () => {
    setTo(
      setTimeout(() => {
        setShowing(false);
      }, ClientInfo.flashbanged?.duration || 3000),
    );
  };

  const onExited = () => {
    dispatchNUI('CLEAR_FLASHBANGED');
  };

  return (
    <Fade in={showing} onEntered={onEntered} onExited={onExited}>
      <div>
        <div className="flashbang_wrapper" style={{ opacity: ClientInfo.flashbanged?.strength || 0 }}></div>
      </div>
    </Fade>
  );
};

export default Flashbang;
