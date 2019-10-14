import * as React from "react"
import { Flex, Input, Spinner, ArtworkIcon } from "@artsy/palette"

import gql from "graphql-tag"
import { useMutation } from "@apollo/react-hooks"
import { useState, useEffect } from "react";
import { IncomingMessage } from "http";


interface Props {
  place: any
  me: any
}

const UPLOAD_PHOTO_MUTATION = gql`
  mutation UploadPlacePhoto($placeId: ID!, $photo: Upload!){
    uploadPlacePhoto(placeId: $placeId, photo: $photo){
      id
    }
  }
`

export const PhotoUpload = (props: Props) => {
  const {me, place} = props
  if (!me || !place) {
    return(null)
  }
  const [fileUpload, setFileUpload] = useState(null)
  const [uploadPhotoMutation, { data, loading: uploading, error: uploadError }] = useMutation(UPLOAD_PHOTO_MUTATION)
  useEffect(() => {
    uploadPhotoMutation({variables:{placeId: place.id, photo: fileUpload}})
  }, [fileUpload])

  if (data) {
    window.location.reload()
  }
  return(
    <Flex flexDirection="row" mr={1} ml={1}>
      <Input type="file" name="file" onChange={e => setFileUpload(e.target.files[0])} hidden={true} id="uploadInput" name="uploadInput"/>
      <label htmlFor="uploadInput" style={{cursor: "pointer"}}><ArtworkIcon width={25} height={25}/></label>
      {uploading && <Spinner />}
    </Flex>
  )
}

export default PhotoUpload