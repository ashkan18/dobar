export const randomFromList = function (list: Array<any>) {
  return list[Math.floor((Math.random()*list.length))];
}