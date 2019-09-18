import {useState, useEffect} from 'react'

export const usePosition = () => {
  const [position, setPosition] = useState();
  const [error, setError] = useState();

  const onFetched = (position:Position) => {
    setPosition(position);
  };
  const onError = (error: any) => {
    setError(error.message);
  };
  useEffect(() => {
    const geo = navigator.geolocation
    if (!("geolocation" in navigator)) {
      setError('Geolocation is not supported');
      return;
    }
    navigator.geolocation.getCurrentPosition(onFetched, onError)
  }, []);
  return {position, error};
}