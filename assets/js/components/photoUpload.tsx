import * as React from "react"
import { Flex, Button, Input, Spinner } from "@artsy/palette"

import gql from "graphql-tag"
import { useMutation } from "@apollo/react-hooks"
import { useState } from "react";


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
  if (data) {
    window.location.reload()
  }
  return(
    <Flex flexDirection="row">
      <Input type="file" name="file" onChange={e => setFileUpload(e.target.files[0])}/>
      {uploading && <Spinner />}
      {!uploading && <Button onClick={ _e => uploadPhotoMutation({variables:{placeId: place.id, photo: fileUpload}})}>Upload</Button> }
    </Flex>
  )
}

export default PhotoUpload