import * as React from "react"
import { Spinner, Flex, Sans, CheckIcon, CloseIcon } from "@artsy/palette"

import gql from "graphql-tag";
import { useMutation, useQuery } from "@apollo/react-hooks";
import { useState } from "react";
import { Link } from "react-router-dom";

interface Props {
  place: any
}

const ME_QUERY = gql`
  query {
    me {
      name
    }
  }
`

const DOBAR_MUTATION  = gql`
  mutation Dobar($placeId: ID!, $response: Boolean) {
    dobar(placeId: $placeId, response: $response) {
      id
    }
  }
`
const RIDESHARE_DOBAR_MUTATION  = gql`
  mutation Rideshare($placeId: ID!, $response: Boolean) {
    rideshareDobar(placeId: $placeId, response: $response) {
      id
    }
  }
`

export const Questions = (props: Props) => {
  const {place} = props
  const {loading: meLoading, data} = useQuery(ME_QUERY)
  const [haveBeenToPlace, setHaveBeenToPlace] = useState(false)
  const [dobar, setDobar] = useState(false)
  const [rideshare, setRideshare] = useState(false)
  const [dobarMutation, { loading: dobarLoading, error: dobarError }] = useMutation(DOBAR_MUTATION)
  const [rideshareMutation, { loading: rideshareLoading, error: rideshareError }] = useMutation(RIDESHARE_DOBAR_MUTATION)
  const dobarResponse = (response: boolean) => {
    dobarMutation({variables: {placeId: place.id, response: response}})
    setDobar(response)
  }
  const rideshareResponse = (response: boolean) => {
    rideshareMutation({variables: {placeId: place.id, response: response}})
    setRideshare(response)
  }
  if (data && data.me) {
    const {me} = data
    return(
      <Flex flexDirection="column" justifyContent="space-between" mt={2}>
        <Flex flexDirection="row">
          <Sans size={5}>{me && `${me.name}, `} Have you been to {place.name}?</Sans>
          <CheckIcon ml={2} height={30} width={30} opacity={haveBeenToPlace === true ? 1 : 0.2} onClick={ _e => setHaveBeenToPlace(true)}/>
        </Flex>
        {haveBeenToPlace &&
          <Flex flexDirection="row">
            <Sans size={5}>Would you go to this place again?</Sans>
            <CheckIcon ml={2} height={30} width={30} opacity={dobar === true ? 1 : 0.2} onClick={ _e => dobarResponse(true)}/>
            <CloseIcon ml={2} height={30} width={30} opacity={dobar === false ? 1 : 0.2} onClick={ _e => dobarResponse(false)}/>
            {dobarLoading && <Spinner/>}
          </Flex>
        }
        {dobar &&
          <Flex flexDirection="row">
            <Sans size={5}>You are 3 miles away from {place.name}, would you use a rideshare service to go there?</Sans>
            <CheckIcon ml={2} height={30} width={30} opacity={rideshare === true ? 1 : 0.2} onClick={ _e => rideshareResponse(true)}/>
            <CloseIcon ml={2} height={30} width={30} opacity={rideshare === false ? 1 : 0.2} onClick={ _e => rideshareResponse(false)}/>
            {rideshareLoading && <Spinner/>}
          </Flex>
        }
      </Flex>
    )
  } else {
    return(
      <Flex flexDirection="column" justifyContent="space-between" mt={2}>
        <Sans size={3}> Please <Link to="/login">Login</Link> to check in.</Sans>
        <Flex flexDirection="row" style={{opacity: 0.2}} mt={1}>
          <Sans size={5}>Have you been to {place.name}?</Sans>
          <CheckIcon ml={2} height={30} width={30}/>
        </Flex>
      </Flex>
    )
  }
}
