import * as React from "react"
import { Spinner, Flex, Sans, CheckIcon, CloseIcon } from "@artsy/palette"

import gql from "graphql-tag";
import { useMutation } from "@apollo/react-hooks";
import { useState } from "react";

interface Props {
  place: any
}

const DOBAR_MUTATION  = gql`
  mutation Dobar($placeId: ID!, $response: Boolean) {
    dobar(placeId: $placeId, response: $response) {
      id
    }
  }
`
const RIDESHARE_DOBAR_MUTATION  = gql`
  mutation Rideshare($placeId: ID!, $response: Boolean) {
    rideshare(placeId: $placeId, response: $response) {
      id
    }
  }
`

export const Questions = (props: Props) => {
  const {place} = props
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
  return(
    <Flex flexDirection="column" justifyContent="space-between">
      <Flex flexDirection="row">
        <Sans size={5}>Have you been to {place.name}?</Sans>
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
}