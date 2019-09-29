import * as React from "react"
import { Sans, Flex, Join, Spacer, Input, Button, Box } from "@artsy/palette";
import { useState } from "react";
import gql from "graphql-tag";
import { useLazyQuery } from "@apollo/react-hooks";

export interface Props{
  onFinish(): void
}


const FIND_PLACES = gql`
  query findPlaces($location: LocationInput, $address: String, $term: String) {
    places(first: 20, location: $location, address: $address, term: $term){
      edges{
        node{
          id
          name
          workingHours
          tags
          images {
            urls {
              original
              thumb
            }
          }
        }
      }
    }
  }
`

export const Onboarding = (props: Props) => {
  const {onFinish} = props
  const [step, setStep] = useState(0)
  const [address, setAddress] = useState("")
  const [search, { called, loading, error: queryError, data }] = useLazyQuery(FIND_PLACES)
  const [currentPlace, setCurrentPlace] = useState()
  const [places, setPlaces] = useState()
  const [responseCount, setResponseCount] = useState(0)

  const haveBeen = () => {
    setCurrentPlace(places.pop())
    setResponseCount(responseCount + 1)
    if (responseCount === 3) {
      onFinish()
    }
  }

  const nope = () => {
    setCurrentPlace(places.pop())
  }

  const findPlaces = () => {
    search({variables: { location: {lat: 40.6898121, lng: -73.9835653}}})
  }

  if (data && step === 0 && !places) {
    setStep(1)
    const placesResponse = data.places.edges.reverse().map(p => p.node)
    setPlaces(placesResponse)
    setCurrentPlace(placesResponse.pop())
  }


  return (
    <Box>
    {step === 0 &&
        <>
          <Sans size={4}>Lets start by finding your taste in restaurants around you!</Sans>
          <Flex flexDirection="row" mt={0}>
            <Input placeholder="Address/Neighborhood" onChange={ e => setAddress(e.currentTarget.value) } value={address || ""} />
            <Button onClick={() => findPlaces()}>Next</Button>
          </Flex>
        </>
      }
      {
        step === 1 &&
        <>
          <Sans size={4}>Have you been to {currentPlace.name}</Sans>
          <Button onClick={haveBeen}>Yes! of course!</Button>
          <Button onClick={nope}>Nope!</Button>
        </>
      }
    </Box>
  )
}
