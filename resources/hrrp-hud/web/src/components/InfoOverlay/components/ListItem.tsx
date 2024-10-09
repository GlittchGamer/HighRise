import { ListItem, ListItemText } from "@mui/material";
import React from "react";

type Props = {
  label: string;
  description: string;
  disabled?: boolean;
};

import "./ListItem.scss";

const CustomListItem = (props: Props) => {
  return (
    <ListItem className="ListItem_Wrapper">
      <ListItemText
        primary={<span className={"primaryText"}>{props.label}</span>}
        // secondary={<span className={'secondaryText'}>{Sanitize(props.description)}</span>}
        secondary={<span className={"secondaryText"}>{props.description}</span>}
      />
    </ListItem>
  );
};

export default CustomListItem;
