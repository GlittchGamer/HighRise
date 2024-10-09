import './List.scss';

import useKeypress from 'react-use-keypress';
import { NUI } from '@/util/NUI';
import { Grid, IconButton, List, Typography, Paper, Box } from '@mui/material';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import ListItemAction from './components/ListItem';
import useData from '@/hooks/useData';
import { dispatchNUI } from '@/util/dispatchNUI';

const ListMenu = () => {
  const { List: ListData } = useData();

  const menu = ListData.menus[ListData.active];

  useKeypress(['Escape'], () => {
    if (!ListData.showing) return;
    else onClose();
  });

  const onBack = () => {
    NUI.Send('ListMenu:Back');
    dispatchNUI('LIST_GO_BACK', {});
  };

  const onClose = () => {
    NUI.Send('ListMenu:Close');
  };

  if (!ListData.showing || !menu) return null;
  return (
    <div className="list_wrapper">
      <Box component={Paper} className="list_box">
        <div className="list_header">
          <Paper elevation={0} className="list_header_paper">
            <Typography textAlign={'center'} fontWeight={400} fontSize={24}>
              {menu?.label ?? 'List'}
            </Typography>
          </Paper>
        </div>

        <Grid container className="list_grid">
          <Grid item xs={4} style={{ textAlign: 'right' }}>
            {Boolean(ListData.stack) && ListData.stack.length > 0 && (
              <IconButton className="headerAction" onClick={onBack}>
                <FontAwesomeIcon icon={['fas', 'arrow-left']} />
              </IconButton>
            )}
            <IconButton className="headerAction" onClick={onClose}>
              <FontAwesomeIcon icon={['fas', 'x']} />
            </IconButton>
          </Grid>
        </Grid>

        <List className="list">
          {menu.items.map((item, k) => (
            <ListItemAction key={`${ListData.active}-${k}`} index={k} item={item} />
          ))}
        </List>
      </Box>
    </div>
  );
};

export default ListMenu;
