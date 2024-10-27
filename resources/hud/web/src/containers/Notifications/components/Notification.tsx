import React from 'react';
import Moment from 'react-moment';
import useInterval from 'react-useinterval';
import { Slide } from '@mui/material';

type Props = {
  notification: Notifications;
};

import './Notification.scss';
import { Sanitize } from '@/util/misc';
import { Notifications } from '@/types/DataProviderTypes';
import { dispatchNUI } from '@/util/dispatchNUI';

const Notification = (props: Props) => {
  const [fin, setFin] = React.useState(false);
  const [timer, setTimer] = React.useState(0);
  React.useEffect(() => {
    setFin(true);
  }, []);

  React.useEffect(() => {
    if (props.notification.duration > 0 && timer >= props.notification.duration) {
      setTimeout(() => {
        setFin(false);
      }, 250);
    }
  }, [timer]);

  React.useEffect(() => {
    if (props.notification.hide) {
      setFin(false);
    }
  }, [props.notification]);

  const onHide = () => {
    dispatchNUI('REMOVE_ALERT', {
      id: props.notification._id,
    });
  };

  const onTick = () => {
    setTimer(timer + 100);
  };

  useInterval(onTick, props.notification.duration < 0 || timer >= props.notification.duration ? null : 100);

  return (
    <Slide direction="left" in={fin} onExited={onHide}>
      <div className="notifContainer relative break-words">
        <div className={`left-top-border border-${props.notification.type}`}></div>
        <div className={`left-bottom-border border-${props.notification.type}`}></div>
        <div className={`top-left-border border-${props.notification.type}`}></div>
        <div className={`top-right-border border-${props.notification.type}`}></div>
        <div className={`notif notif-${props.notification.type}`}>{Sanitize(props.notification.message)}</div>
        <div className={`bottom-right-border border-${props.notification.type}`}></div>
        <div className={`bottom-left-border border-${props.notification.type}`}></div>
        <div className={`right-top-border border-${props.notification.type}`}></div>
        <div className={`right-bottom-border border-${props.notification.type}`}></div>
      </div>
    </Slide>
  );
};

export default Notification;
