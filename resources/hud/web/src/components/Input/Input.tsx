import { NUI } from '@/util/NUI';

import useKeypress from 'react-use-keypress';
import { NumericFormat } from 'react-number-format';

import { Button, Dialog, DialogActions, DialogContent, DialogTitle, MenuItem, TextField } from '@mui/material';

import './Input.scss';
import useData from '@/hooks/useData';

const Input = () => {
  const { Input: InputData } = useData();

  const onSubmit = (e) => {
    e.preventDefault();

    let res = Object();
    InputData.inputs.forEach((inp) => {
      res[inp.id] = e.target[inp.id].value;
    });

    NUI.Send('Input:Submit', {
      event: InputData.event,
      values: res,
      data: InputData.data,
    });
  };
  const onClose = () => {
    NUI.Send('Input:Close');
  };

  useKeypress(['Escape'], () => {
    onClose();
  });

  const getInputType = (name, type, options, config) => {
    switch (type) {
      case 'number':
        return <NumericFormat fullWidth isNumericString id={name} name={name} label={InputData.label} className={'input'} customInput={TextField} {...options} />;
      case 'multiline':
        return <TextField autoFocus fullWidth multiline minRows={3} id={name} name={name} label={InputData.label} className={'input'} {...options} />;
      case 'select':
        return (
          <TextField select autoFocus fullWidth multiline minRows={3} id={name} name={name} label={InputData.label} className={'input'} {...options}>
            {config.select.map((option) => (
              <MenuItem key={option.value} value={option.value}>
                {option.label}
              </MenuItem>
            ))}
          </TextField>
        );
      case 'text':
      default:
        return <TextField autoFocus fullWidth id={name} name={name} label={InputData.label} className={'input'} {...options} />;
    }
  };

  if (!InputData.showing) return null;
  return (
    <Dialog fullWidth maxWidth="sm" open={true} onClose={onClose} className="input_wrapper">
      <form onSubmit={onSubmit}>
        <DialogTitle>{InputData.title}</DialogTitle>
        <DialogContent style={{ paddingTop: 15, overflow: 'hidden' }}>
          {InputData.inputs.map((inp) => {
            return getInputType(inp.id, inp.type, inp.options, inp);
          })}
        </DialogContent>
        <DialogActions>
          <Button onClick={onClose} color="inherit">
            Cancel
          </Button>
          <Button type="submit">Submit</Button>
        </DialogActions>
      </form>
    </Dialog>
  );
};

export default Input;
