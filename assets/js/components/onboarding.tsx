import * as React from "react"
import { BorderBox, Sans, Flex, Join, Spacer, Input, Button } from "@artsy/palette";
import { useState } from "react";
import gql from "graphql-tag";
import { useLazyQuery } from "@apollo/react-hooks";

export interface Props{
  onFinish(): void
}


const FIND_PLACES = gql`
  query findPlaces($location: LocationInput, $address: String, $term: String) {
    places(first: 10, location: $location, address: $address, term: $term){
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
  if (data) {
    setStep(1)
  }
  return (
    <BorderBox>
      {step === 0 &&
        <Join separator={<Spacer m={1}/>}>
          <Sans size={4}>Lets start by finding your taste in restaurants around you!</Sans>
          <Input placeholder="Address/Neighborhood" onChange={ e => setAddress(e.currentTarget.value) } value={address || ""} />
          <Button onClick={() => search({variables: {address}})}>Next</Button>
        </Join>
      }
    </BorderBox>
  )
}
