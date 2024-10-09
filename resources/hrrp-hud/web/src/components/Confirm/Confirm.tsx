import { Sanitize } from '@/util/misc';
import { NUI } from '@/util/NUI';
import { Button, Dialog, DialogActions, DialogContent, DialogTitle } from '@mui/material';

import useKeypress from 'react-use-keypress';

import './Confirm.scss';
import useData from '@/hooks/useData';

const Confirm = () => {
  const { Confirm: ConfirmData } = useData();

  const onAccept = () => {
    NUI.Send('Confirm:Yes', {
      event: ConfirmData.yes,
      data: ConfirmData.data,
    });
  };

  const onClose = () => {
    NUI.Send('Confirm:No', {
      event: ConfirmData.no,
      data: ConfirmData.data,
    });
  };

  useKeypress(['Escape'], () => {
    onClose();
  });

  return (
    <Dialog fullWidth maxWidth="sm" open={true} onClose={onClose}>
      <DialogTitle>{ConfirmData.title}</DialogTitle>
      {Boolean(ConfirmData.description) && <DialogContent style={{ paddingTop: 15, overflow: 'hidden' }}>{Sanitize(ConfirmData.description)}</DialogContent>}
      <DialogActions>
        <Button onClick={onClose} color="error">
          {ConfirmData.denyLabel ?? 'No'}
        </Button>
        <Button onClick={onAccept} color="success">
          {ConfirmData.acceptLabel ?? 'Yes'}
        </Button>
      </DialogActions>
    </Dialog>
  );
};

export default Confirm;
