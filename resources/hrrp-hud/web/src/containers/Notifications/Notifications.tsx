import React from 'react';
import Notification from './components/Notification';

import useData from '@/hooks/useData';
import './Notifications.scss';

const Notifications = () => {
  const { Notifications: Notifs } = useData();
  return React.useMemo(
    () => (
      <div className="notif_wrapper -skew-y-3">
        {Notifs.notifications.length > 0 &&
          Notifs.notifications
            .sort((a, b) => b.created - a.created)
            .map((n) => {
              return <Notification key={n._id} notification={n} />;
            })}
      </div>
    ),
    [Notifs],
  );
};

export default Notifications;
