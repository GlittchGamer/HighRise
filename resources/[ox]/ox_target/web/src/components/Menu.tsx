import { Interact } from '@/App';
import { modFilteredItems } from '@/util/modFilteredItems';
import { NUI } from '@/util/NUI';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import React from 'react';

type Props = {
  items: Interact[];
};

const Menus = (props: Props) => {
  const leftItems = modFilteredItems(props.items, 0);
  const rightItems = modFilteredItems(props.items, 1);

  const canRenderBottom = props.items.length === 1;
  const firstAction = props.items[0];

  const clickHandler = (event: React.MouseEvent<HTMLDivElement>, action: Interact) => {
    NUI.Send('select', [action.targetType, action.targetId, action.zoneId]);
  };

  return (
    <>
      {leftItems.length > 0 && (
        <div className="menu left">
          {leftItems.map((item, index) => {
            if (item.data.hide) return null;
            return (
              <div key={index} className="item" onClick={(event) => clickHandler(event, item)} onContextMenu={(event) => clickHandler(event, item)}>
                <FontAwesomeIcon icon={['fas', item.data.icon]} size="xs" />
                {item.data.label}
              </div>
            );
          })}
        </div>
      )}
      {rightItems.length > 0 && (
        <div className="menu right">
          {rightItems.map((item, index) => {
            if (item.data.hide) return null;
            return (
              <div key={index} className="item" onClick={(event) => clickHandler(event, item)} onContextMenu={(event) => clickHandler(event, item)}>
                <FontAwesomeIcon icon={['fas', item.data.icon]} size="xs" />
                {item.data.label}
              </div>
            );
          })}
        </div>
      )}

      {canRenderBottom && (
        <div className="menu bottom">
          <div className="item" onClick={(event) => clickHandler(event, firstAction)} onContextMenu={(event) => clickHandler(event, firstAction)}>
            <FontAwesomeIcon icon={['fas', firstAction.data.icon]} size="xs" />
            {firstAction.data.label}
          </div>
        </div>
      )}
    </>
  );
};

export default Menus;
