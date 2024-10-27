import './ListItem.scss';

import React from 'react';
import { NUI } from '@/util/NUI';
import { IconButton, ListItem, ListItemButton, ListItemSecondaryAction, ListItemText, useTheme } from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { Sanitize } from '@/util/misc';
import { dispatchNUI } from '@/util/dispatchNUI';

type Props = {
  index: number;
  item: {
    actions: any;
    event: string;
    submenu: any;
    label: string;
    description: string;
    data: any;
    disabled: boolean;
  };
};

const ListItemAction = (props: Props) => {
  const onClick = () => {
    if (props.item.submenu) {
      NUI.Send('ListMenu:SubMenu', {
        submenu: props.item.submenu,
      });

      dispatchNUI('CHANGE_MENU', {
        menu: props.item.submenu,
      });
    } else if (props.item.event) {
      NUI.Send('ListMenu:Clicked', {
        event: props.item.event,
        data: props.item.data,
      });
    }
  };

  const onAction = (event) => {
    NUI.Send('ListMenu:Clicked', {
      event: event,
      data: props.item.data,
    });
  };

  const theme = useTheme();

  return (
    <ListItem
      divider
      className={`listItem_wrapper clickable`}
      onClick={!Boolean(props.item.actions) && (Boolean(props.item.event) || Boolean(props.item.submenu)) ? onClick : null}
      disablePadding
      sx={{
        background: theme.palette.secondary.main,
        '&:hover': {
          background: theme.palette.secondary.main,
        },
      }}
    >
      <ListItemButton disabled={Boolean(props.item.disabled)}>
        <ListItemText primary={props.item.label} secondary={<span>{Sanitize(props.item.description)}</span>} />
        {Boolean(props.item.submenu) ? (
          <ListItemSecondaryAction className={'phw'}>
            <IconButton disabled className={'ph'} sx={{ background: theme.palette.primary.main }}>
              <FontAwesomeIcon icon={['fas', 'chevron-right']} />
            </IconButton>
          </ListItemSecondaryAction>
        ) : Boolean(props.item.actions) ? (
          <ListItemSecondaryAction className={'phw'}>
            {props.item.actions.map((action, k) => {
              return (
                <IconButton key={`${props.index}-action-${k}`} onClick={() => onAction(action.event)} className={'action'}>
                  <FontAwesomeIcon icon={['fas', action.icon]} />
                </IconButton>
              );
            })}
          </ListItemSecondaryAction>
        ) : null}
      </ListItemButton>
    </ListItem>
  );
};

export default ListItemAction;
