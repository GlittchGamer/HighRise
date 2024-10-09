export const initialState = {
  showing: false,
  info: "",
};

export const gemReducer = (state = initialState, action) => {
  switch (action.type) {
    case "SHOW_GEM_TABLE":
      return {
        ...state,
        showing: true,
        info: action.payload.info,
      };
    case "CLOSE_GEM_TABLE":
      return {
        ...state,
        showing: false,
      };
    default:
      return state;
  }
};
